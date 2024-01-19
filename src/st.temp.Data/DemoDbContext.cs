namespace st.temp.Data;

using Microsoft.EntityFrameworkCore;
using System;

public class DemoDbContext : DbContext
    {
        public DemoDbContext()
        {
        }

        public DemoDbContext(DbContextOptions<DemoDbContext> options)
        : base(options)
        {
        }
        public DbSet<KeyingSystem> KeyingSystems { get; set; }
        public DbSet<AppUser> AppUsers { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            if (modelBuilder is null)
            {
                throw new ArgumentNullException(nameof(modelBuilder));
            }

            var declaringAssembly = this.GetType().Assembly;
            modelBuilder.ApplyConfigurationsFromAssembly(declaringAssembly);
        }
    }

