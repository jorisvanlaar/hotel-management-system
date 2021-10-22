using HotelAppLibrary.Data;
using HotelAppLibrary.Models;
using System;
using System.Windows;

namespace HotelApp.Desktop
{
    /// <summary>
    /// Interaction logic for CheckInForm.xaml
    /// </summary>
    public partial class CheckInForm : Window
    {
        private readonly IDatabaseData _db;
        private BookingFullModel _data = null;

        public CheckInForm(IDatabaseData db)
        {
            InitializeComponent();
            _db = db;
        }

        public void PopulateCheckInInfo(BookingFullModel data)
        {
            _data = data;

            firstNameText.Text = _data.FirstName;
            lastNameText.Text = _data.LastName;
            titleText.Text = _data.Title;
            roomNumberText.Text = _data.RoomNumber;
            totalCostText.Text = String.Format("{0:C}", _data.TotalCost);
        }

        private void ConfirmCheckIn_Click(object sender, RoutedEventArgs e)
        {
            _db.CheckInGuest(_data.Id);

            this.Close();
        }
    }
}
