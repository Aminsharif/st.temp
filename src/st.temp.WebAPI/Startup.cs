using FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;
using Serilog;
using st.temp.common;
using st.temp.Common;
using st.temp.Common.Configuration;
using st.temp.DependencyInjection.Data;
using st.temp.DependencyInjection.MediatR;
using st.temp.DependencyInjection.Serilog;
using st.temp.WebAPI.Authentication;
using st.temp.WebAPI.Middleware.AuthenticateAlways;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Text;

namespace st.temp.WebAPI
{
  public class Startup
  {
        private string corspolicy = "CorsPolicy";

        public Startup(IConfiguration configuration)
        {
            this.Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services
              .AddDatabase()
              .AddMediatrAndAutomapper(new[] { typeof(Startup) })
              .ConfigureSerilog(this.Configuration);

            services.AddCors(options =>
            {
                options.AddPolicy(
                  this.corspolicy,
                  builder =>
                  {
                    builder
                    .AllowAnyMethod()
                    .AllowAnyHeader()
                    .SetIsOriginAllowed(origin => true)
                    .AllowCredentials();
                  });
            });

            JwtSecurityTokenHandler.DefaultInboundClaimTypeMap.Clear();
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            // Adding Security
            var key = this.Configuration.GetValue<string>("SecurityKey");
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
            services
              .AddSingleton<SecurityKey>(securityKey)
              .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
              .AddJwtBearer(options =>
              {
                  options.RequireHttpsMetadata = false;
                  options.SaveToken = true;
                  options.TokenValidationParameters = new TokenValidationParameters
                  {
                      ValidateIssuerSigningKey = true,
                      IssuerSigningKey = securityKey,
                      ValidateIssuer = false,
                      ValidateAudience = false,
                  };
              });

            services.AddAuthorization(options =>
            {
                options.AddPolicy(PolicyName.AuthenticatedReader, builder =>
                {
                    builder.RequireAuthenticatedUser();
                    builder.RequireRole(UserRoleNames.AMReader, UserRoleNames.AMWriter);
                });

                options.AddPolicy(PolicyName.AuthenticatedWriter, builder =>
                {
                    builder.RequireAuthenticatedUser();
                    builder.RequireRole(UserRoleNames.AMWriter);
                });
            });

            services.AddHttpContextAccessor();

            services.AddScoped<ICurrentUserInfo>(provider =>
            {
                var httpContextAccessor = provider.GetService<IHttpContextAccessor>();

                if (httpContextAccessor?.HttpContext == null)
                {
                    return new StaticCurrentUserInfo("System", UserRoleNames.AMReader);
                }

                return new ClaimsPrincipalCurrentUserInfo(httpContextAccessor.HttpContext.User);
            });

          services
            .AddControllers()
            .AddNewtonsoftJson(options =>
            {
              options.SerializerSettings.Converters = new List<JsonConverter>
                { new StringEnumConverter { NamingStrategy = new CamelCaseNamingStrategy() } };
            })
          .AddFluentValidation(fv => fv.RegisterValidatorsFromAssemblyContaining<Startup>());

          services.AddAuthenticateAlwaysMiddleware();

          services.Configure<ActiveDirectoryConfiguration>(this.Configuration.GetSection("ActiveDirectoryConfiguration"));
          services.Configure<SessionConfiguration>(this.Configuration.GetSection("SessionConfiguration"));

          services.AddEndpointsApiExplorer();

          services.AddSwaggerGen(options =>
          {
              options.SwaggerDoc(
                      "v1",
                      new OpenApiInfo
                      {
                        Title = "st.temp.WebAPI",
                        Version = "v1",
                      });

              options.TagActionsBy(api => new[] { api.GroupName });
              options.DocInclusionPredicate((name, api) => true);

              options.AddSecurityDefinition(
                      "Bearer",
                      new OpenApiSecurityScheme
                      {
                        Name = "Authorization",
                        Type = SecuritySchemeType.ApiKey,
                        Scheme = "Bearer",
                        BearerFormat = "JWT",
                        In = ParameterLocation.Header,
                        Description = "JWT Authorization header using the Bearer scheme.",
                      });

            options.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
              {
                new OpenApiSecurityScheme
                {
                  Scheme = "Bearer",
                  Reference = new OpenApiReference
                  {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer",
                  },
                },
                new string[] { }
              },
            });
          });
        }
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            app.UseCors(this.corspolicy);
            if (env == null)
            {
                throw new ArgumentNullException(nameof(env));
            }

            if (!env.IsProduction())
            {
              app.UseDeveloperExceptionPage();
              app.UseSwagger();
              app.UseSwaggerUI();
            }
            else
            {
                app.UseExceptionHandler(options =>
                {
                    options.Run(async context =>
                    {
                        Log.Logger.Fatal("unhandled exception");

                        context.Response.StatusCode = 500;
                        await context.Response
                          .WriteAsync("internal server error");
                    });
                });
            }

            app.UseCors(this.corspolicy);

            if (env.EnvironmentName == "Local")
            {
                app.UseAuthenticateAlways();
            }

            app.UseSerilogRequestLogging();

            app.UseHttpsRedirection();

            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(
              endpoints => { endpoints.MapControllers(); });
        }
  }
}

