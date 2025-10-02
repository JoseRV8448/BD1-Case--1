namespace Merkadit.Models
{
    public class Roles
    {
        public long Id { get; set; }   
        public string name { get; set; }  
        public string description { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }

        public ICollection<UserRoles> UserRoles { get; set; }
    }
}
