using HotelAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.ComponentModel.DataAnnotations;

namespace HotelAppUI.Models
{
    public class BookRoomModel
    {
        [BindProperty(SupportsGet = true)]
        public int RoomTypeId { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime StartDate { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime EndDate { get; set; }

        [Required]
        [Display(Name = "First Name")]
        [BindProperty(SupportsGet = true)]
        public string FirstName { get; set; }

        [Required]
        [Display(Name = "Last Name")]
        [BindProperty(SupportsGet = true)]
        public string LastName { get; set; }

        public RoomTypeModel RoomType { get; set; }
    }
}
