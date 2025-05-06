using Google.Cloud.Firestore;

namespace tappoapi.Models
{
    [FirestoreData]
    public class DeviceModel
    {
        // This is the document ID (MAC address)
        public string MacAddress { get; set; }

        [FirestoreProperty("activationTime")]
        public string ActivationTime { get; set; }

        [FirestoreProperty("deactivationTime")]
        public string DeactivationTime { get; set; }

        [FirestoreProperty("description")]
        public string Description { get; set; }

        [FirestoreProperty("name")]
        public string Name { get; set; }

        [FirestoreProperty("status")]
        public string Status { get; set; }
    }
}
