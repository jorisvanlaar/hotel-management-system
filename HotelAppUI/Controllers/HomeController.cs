using HotelAppLibrary.Data;
using HotelAppUI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Diagnostics;

namespace HotelAppUI.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IDatabaseData _db;

        public HomeController(ILogger<HomeController> logger, IDatabaseData db)
        {
            _logger = logger;
            _db = db;
        }

        public IActionResult Index()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IActionResult RoomSearch(RoomSearchModel model)
        {
            if (model.SearchEnabled)
            {
                model.AvailableRoomTypes = _db.GetAvailableRoomTypes(model.StartDate, model.EndDate);
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult RoomSearch(IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(RoomSearch), new { StartDate = collection["StartDate"], 
                                                                EndDate = collection["EndDate"], 
                                                                SearchEnabled = true });
            }
            catch
            {
                return View();
            }
        }

        public IActionResult BookRoom(BookRoomModel model)
        {
            ModelState.Clear();

            if (model.RoomTypeId > 0)
            {
                model.RoomType = _db.GetRoomTypeById(model.RoomTypeId);
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult BookRoom(IFormCollection collection, BookRoomModel model)
        {
            try
            {
                _db.BookGuest(collection["FirstName"], collection["LastName"], model.StartDate, model.EndDate, model.RoomTypeId);
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}
