using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/users")]
public class UsersController : ControllerBase
{
    private readonly FirebaseService _firebase;

    public UsersController(FirebaseService firebase)
    {
        _firebase = firebase;
    }

    // GET: /api/users/{userId}
    [HttpGet("{userId}")]
    public async Task<IActionResult> GetUser(string userId)
    {
        var user = await _firebase.GetUserAsync(userId);
        if (user == null) return NotFound();

        return Ok(user);
    }

    // GET: /api/users/{userId}/devices
    [HttpGet("{userId}/devices")]
    public async Task<IActionResult> GetUserDevices(string userId)
    {
        var devices = await _firebase.GetUserDevicesAsync(userId);
        return Ok(devices);
    }
}
