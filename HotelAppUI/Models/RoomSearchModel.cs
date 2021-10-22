using HotelAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HotelAppUI.Models
{
    public class RoomSearchModel
    {
        [Required]
        [DataType(DataType.Date)]
        [Display(Name = "Start Date")]
        [BindProperty(SupportsGet = true)]
        public DateTime StartDate { get; set; } = DateTime.Now;

        [Required]
        [DataType(DataType.Date)]
        [Display(Name = "End Date")]
        [BindProperty(SupportsGet = true)]
        public DateTime EndDate { get; set; } = DateTime.Now.AddDays(1);

        [BindProperty(SupportsGet = true)]
        public bool SearchEnabled { get; set; } = false;

        public List<RoomTypeModel> AvailableRoomTypes { get; set; }
    }
}
