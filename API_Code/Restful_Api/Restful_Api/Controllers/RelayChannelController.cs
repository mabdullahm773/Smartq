using Devices.Data;
using Devices.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Devices.Controllers
{
    [ApiController]
    [Route("/relay")]
    public class RelayChannelController : ControllerBase
    {
        private readonly AppDbContext _context;

        public RelayChannelController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/relay
        [HttpGet]
        public async Task<ActionResult<IEnumerable<RelayChannel>>> GetAll()
        {
            return await _context.RelayChannels.ToListAsync();
        }

        // GET: api/relay/5
        [HttpGet("{id}")]
        public async Task<ActionResult<RelayChannel>> GetById(int id)
        {
            var relay = await _context.RelayChannels.FindAsync(id);
            if (relay == null)
                return NotFound();

            return Ok(relay);
        }

        // POST: api/relay
        [HttpPost]
        public async Task<ActionResult<RelayChannel>> Create([FromBody] RelayChannel relay)
        {
            _context.RelayChannels.Add(relay);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = relay.Id }, relay);
        }

        // PUT: api/relay/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] RelayChannel relay)
        {
            if (id != relay.Id)
                return BadRequest("ID mismatch");

            _context.Entry(relay).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RelayChannelExists(id))
                    return NotFound();
                else
                    throw;
            }

            return NoContent();
        }

        // DELETE: api/relay/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var relay = await _context.RelayChannels.FindAsync(id);
            if (relay == null)
                return NotFound();

            _context.RelayChannels.Remove(relay);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RelayChannelExists(int id)
        {
            return _context.RelayChannels.Any(e => e.Id == id);
        }
    }
}
