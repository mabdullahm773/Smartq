using Google.Cloud.Firestore;
using tappoapi.Models;

public class FirebaseService
{
    private readonly FirestoreDb _db;

    public FirebaseService()
    {
        Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "firebase_key.json");

        _db = FirestoreDb.Create("tappo-8a692");
    }

    public async Task<UserModel?> GetUserAsync(string userId)
    {
        DocumentReference docRef = _db.Collection("users").Document(userId);
        DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();

        // Debug: Print snapshot data
        Console.WriteLine($"Document exists: {snapshot.Exists}");
        if (snapshot.Exists)
        {
            // Print raw data
            var data = snapshot.ToDictionary();
            foreach (var kvp in data)
            {
                Console.WriteLine($"Key: {kvp.Key}, Value: {kvp.Value}");
            }

            var user = snapshot.ConvertTo<UserModel>();
            user.UserId = userId;
            return user;
        }
        else
        {
            return null;
        }
    }

    public async Task<List<DeviceModel>> GetUserDevicesAsync(string userId)
    {
        var devices = new List<DeviceModel>();
        CollectionReference devicesRef = _db.Collection("users").Document(userId).Collection("devices");
        QuerySnapshot snapshots = await devicesRef.GetSnapshotAsync();

        foreach (var doc in snapshots.Documents)
        {
            var device = doc.ConvertTo<DeviceModel>();
            device.MacAddress = doc.Id;
            devices.Add(device);
        }

        return devices;
    }

    public async Task<List<UserModel>> GetAllUsersAsync()
    {
        var users = new List<UserModel>();
        var query = await _db.Collection("users").GetSnapshotAsync();

        foreach (var doc in query.Documents)
        {
            var user = doc.ConvertTo<UserModel>();
            user.UserId = doc.Id;
            users.Add(user);
        }

        return users;
    }
}
