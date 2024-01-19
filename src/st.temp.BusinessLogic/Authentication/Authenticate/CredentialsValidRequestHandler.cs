namespace st.temp.BusinessLogic.Authentication.Authenticate;

using MediatR;
using st.temp.Data.Queries.Users.UserByIdExists;
using st.temp.Data.Queries.Users.UserByUserName;
using st.temp.Data.Queries.Users.UserByUserNameExists;
using System;
using System.Threading;
using System.Threading.Tasks;

public class CredentialsValidRequestHandler : IRequestHandler<CredentialsValidRequest, bool>
{
    private readonly IMediator mediator;
    public CredentialsValidRequestHandler(IMediator mediator)
    {
        this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
    }

  public async Task<bool> Handle(CredentialsValidRequest request, CancellationToken cancellationToken)
  {

    if (request == null)
    {
      throw new ArgumentNullException(nameof(request));
    }
        if(!await this.mediator.Send(new UserByUserNameExistsQuery(request.Username), cancellationToken)) 
        {
            return false;
        }
        var user = await this.mediator.Send(new UserByUserNameQuery(request.Username),cancellationToken);

        if(user.Password == request.Password)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}