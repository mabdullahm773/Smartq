using Google.Cloud.Firestore;

namespace tappoapi.Models
{
    [FirestoreData]
    public class UserModel
    {
        [FirestoreProperty]
        public string UserId { get; set; }

        [FirestoreProperty("name")]
        public string Name { get; set; }

        [FirestoreProperty("email")]
        public string Email { get; set; }

        [FirestoreProperty("photoURL")]
        public string PhotoURL { get; set; }

        [FirestoreProperty("createdAt")]
        public string CreatedAt { get; set; }
    }

}

//  Ab4k1Hcj6Kehr5DH6pMRSdywLe73
//  NU0vex6OnsTDG1guMvOsJcqAc2p2