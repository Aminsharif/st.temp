namespace st.temp.common;

using System.Collections.Generic;

    public interface ICurrentUserInfo
    {
        public string Username { get; }

        public IEnumerable<string> UserRoles { get; }
    }


