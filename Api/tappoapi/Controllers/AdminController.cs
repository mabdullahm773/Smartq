using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/admin")]
public class AdminController : ControllerBase
{
    private readonly FirebaseService _firebase;

    public AdminController(FirebaseService firebase)
    {
        _firebase = firebase;
    }

    // GET: /api/admin/users
    [HttpGet("users")]
    public async Task<IActionResult> GetAllUsers()
    {
        var users = await _firebase.GetAllUsersAsync();
        return Ok(users);
    }

    // You could add other admin-only features later
}
