   M S B A M L   `   `   `  ����K  GHotelApp.Desktop, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null3clr-namespace:HotelApp.DesktopHotelApp.Desktop  5   	   !    HotelApp.Desktop.MainWindow   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   0localclr-namespace:HotelApp.Desktop     5   	   $��20(�5      $��Segoe UI)�6(     � Title$  Search Today's Bookings��5   	   $	��500��6)   $	��800��66   .��5	      � $��20q�6    � RowDefinitions 5
   
   �� 5      $
��auto �6   �� 5      $
��auto �6   �� 5      $
��auto �6   �� 5      $��* �6    � ColumnDefinitions 5   
   �� 5      $
��auto �6   �� 5      $��* �6   .+�5   
   �� $��0��6   $��0��6!   $��Guest Last Name��5      $��24(�6+   �� 5   
    �� Orientation$ 
Horizontal=�6   $��1��6.   $��0��6;   .+�5      �� -   5         ��Name$ lastNameText��5      $	��200��6,   $��5q�6;   �� 5      -   5         ��Name$ searchForGuest��5      $��5q�6-   $��5q�68   .��5   2   Search6:   5      �� 5   
   -   5         ��Name$ resultsList��5      $��2��6'   $��0��64   $��5 20 5 5q�5      $	��300��6<   $
��Auto=�5      ��5   $   �� ��5      �� 5      .R�5       �  5!      �� 5"      $
��auto �6,   �� 5#      $
��auto �6,   �� 5$      $
��auto �6,   �� 5%      $
��auto �6,   �� 5&      $��* �6,    5(      �� 5)      $
��auto �6/   �� 5*      $
��auto �6/   �� 5+      $��* �6/   .+�5-      �� $ 
Horizontal=�6%   $��0��6>   .+�5.      �� $
��Bold"�6(   $��5q�6:   Reservation:6S   �� 5/      $��5q�6C   ��6(   �� *	FirstName+6C   �� 50      $��5q�6B   ��6(   �� *
LastName+6B   51      �� 52      $ checkIn��6!   -   5        $��5q�52   2   $��10q�6=   $��0��6J   $��1��6W   $��4��53   !   $��Center=�62   .��54   7   
Check-In6A   �� 55      $ 
Horizontal=�6%   $��1��6>   .+�56      �� $
��Bold"�6(   $��5q�6:   Room:6L   �� 57      $��5q�6?   ��6(   �� *Title+6?   58      �� 59      $ 
Horizontal=�6%   $��2��6>   .+�5:      �� $
��Bold"�6(   $��5q�6:   Room Number:6S   �� 5;      $��5q�6D   ��6(   �� *
RoomNumber+6D   5<      �� 5=      $ 
Horizontal=�6%   $��3��6>   .+�5>      �� $
��Bold"�6(   $��5q�6:   Total Cost:6R   �� 5?      $��5q�6U   ��6(   �� *	TotalCost+ �� StringFormat$ c��6U   5@      5A      5B      5D      5E      5F      