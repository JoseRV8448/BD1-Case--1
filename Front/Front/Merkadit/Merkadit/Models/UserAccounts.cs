using System.ComponentModel.DataAnnotations;

namespace Merkadit.Models
{
    public class UserAccounts
    {
        public long Id { get; set; }   
        public string username { get; set; }
        public string password_hash { get; set; }
        public string email { get; set; }
        public string full_name { get; set; }
        public bool is_active { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }

        public ICollection<UserRoles> UserRoles { get; set; }
    }
}
