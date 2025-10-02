namespace Merkadit.Models
{
    public class UserRoles
    {
        public long user_id { get; set; }   
        public long role_id { get; set; }  

        public UserAccounts UserAccount { get; set; }
        public Roles Role { get; set; }
    }
}
