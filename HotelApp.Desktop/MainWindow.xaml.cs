using HotelAppLibrary.Data;
using HotelAppLibrary.Models;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using Microsoft.Extensions.DependencyInjection;

namespace HotelApp.Desktop
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>

    public partial class MainWindow : Window
    {
        private readonly IDatabaseData _db;

        public MainWindow(IDatabaseData db)
        {
            InitializeComponent();
            _db = db;
        }

        private void SearchForGuest_Click(object sender, RoutedEventArgs e)
        {
            List<BookingFullModel> bookings = _db.SearchBookings(lastNameText.Text);
            resultsList.ItemsSource = bookings;
        }

        private void CheckIn_Click(object sender, RoutedEventArgs e)
        {
            var checkInForm = App.serviceProvider.GetService<CheckInForm>();

            var model = (BookingFullModel)((Button)e.Source).DataContext;
            checkInForm.PopulateCheckInInfo(model);

            checkInForm.Show();
        }
    }
}
