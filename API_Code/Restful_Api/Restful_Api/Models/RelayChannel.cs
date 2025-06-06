namespace Devices.Models
{
    public class RelayChannel
    {
        public int Id { get; set; }
        public string? DeviceName { get; set; }
        public bool RelayStatus { get; set; }
    }
}
