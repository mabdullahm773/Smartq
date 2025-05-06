// for multple devies specific to their mac addresses

//using Microsoft.AspNetCore.Mvc;
//using System.Collections.Concurrent;

//namespace LedApi.Controllers
//{
//    [ApiController]
//    [Route("api/[controller]")]
//    public class LedController : ControllerBase
//    {
//        // Store LED states for multiple devices using a thread-safe dictionary
//        private static ConcurrentDictionary<string, bool> LedStates = new ConcurrentDictionary<string, bool>();

//        // GET api/led/{deviceId}/status
//        [HttpGet("{deviceId}/status")]
//        public IActionResult GetLedStatus(string deviceId)
//        {
//            bool state = LedStates.GetValueOrDefault(deviceId, false);
//            return Ok(new { deviceId, state });
//        }

//        // POST api/led/{deviceId}/on
//        [HttpPost("{deviceId}/on")]
//        public IActionResult TurnOnLed(string deviceId)
//        {
//            LedStates[deviceId] = true;
//            return Ok(new { deviceId, message = "LED is ON", state = true });
//        }

//        // POST api/led/{deviceId}/off
//        [HttpPost("{deviceId}/off")]
//        public IActionResult TurnOffLed(string deviceId)
//        {
//            LedStates[deviceId] = false;
//            return Ok(new { deviceId, message = "LED is OFF", state = false });
//        }
//    }
//}


using Microsoft.AspNetCore.Mvc;

namespace LedApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LedController : ControllerBase
    {
        // Simulated LED state (true = ON, false = OFF)
        private static bool LedState = false;

        // Endpoint to get the current LED status
        [HttpGet("status")]
        public IActionResult GetLedStatus()
        {
            return Ok(new { state = LedState });
        }

        // Endpoint to turn the LED ON
        [HttpPost("on")]
        public IActionResult TurnOnLed()
        {
            LedState = true; // Simulate turning the LED ON
            return Ok(new { message = "LED is ON", state = LedState });
        }

        // Endpoint to turn the LED OFF
        [HttpPost("off")]
        public IActionResult TurnOffLed()
        {
            LedState = false; // Simulate turning the LED OFF
            return Ok(new { message = "LED is OFF", state = LedState });
        }
    }
}