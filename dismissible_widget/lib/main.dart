import 'package:flutter/material.dart';

class Trip {
  String id;
  String tripName;
  String tripLocation;

  Trip({required this.id, required this.tripName, required this.tripLocation});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    List<Trip> _trips = []; // Correct syntax for declaring an empty list

  @override
  void initState() {
    super.initState();
    _initializeTrips();
  }

  void _initializeTrips() {
    _trips
      ..add(Trip(id: '0', tripName: 'Rome', tripLocation: 'Italy'))
      ..add(Trip(id: '1', tripName: 'Paris', tripLocation: 'France'))
      ..add(Trip(id: '2', tripName: 'New York', tripLocation: 'USA - New York'))
      ..add(Trip(id: '3', tripName: 'Cancun', tripLocation: 'Mexico'))
      ..add(Trip(id: '4', tripName: 'London', tripLocation: 'England'))
      ..add(Trip(id: '5', tripName: 'Sydney', tripLocation: 'Australia'))
      ..add(Trip(id: '6', tripName: 'Miami', tripLocation: 'USA - Florida'))
      ..add(Trip(id: '7', tripName: 'Rio de Janeiro', tripLocation: 'Brazil'))
      ..add(Trip(id: '8', tripName: 'Cusco', tripLocation: 'Peru'))
      ..add(Trip(id: '9', tripName: 'New Delhi', tripLocation: 'India'))
      ..add(Trip(id: '10', tripName: 'Tokyo', tripLocation: 'Japan'));
  }

  void _markTripCompleted(String tripId) {
    print('Trip with ID $tripId marked as completed.');
    // Implement logic to mark trip completed in Database or web service
  }

  void _deleteTrip(String tripId) {
    print('Trip with ID $tripId deleted.');
    // Implement logic to delete trip from Database or web service
  }

  Container _buildCompleteTrip() {
    return Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.done,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildRemoveTrip() {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(int index) {
    return ListTile(
      title: Text('${_trips[index].tripName}'),
      subtitle: Text(_trips[index].tripLocation),
      leading: Icon(Icons.flight),
      trailing: Icon(Icons.fastfood),
      onTap: () {
        // Handle tap on the list item (you can navigate to a detailed view or perform other actions)
      },
      onLongPress: () {
        // Handle long press on the list item (you can show options like delete or mark as completed)
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip List'),
      ),
      body: ListView.builder(
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_trips[index].id),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // Swiped from right to left (remove)
                _deleteTrip(_trips[index].id); // Placeholder method for deleting a trip
              } else if (direction == DismissDirection.startToEnd) {
                // Swiped from left to right (complete)
                _markTripCompleted(_trips[index].id); // Placeholder method for completing a trip
              }

              // Remove item from the _trips List
              setState(() {
                _trips.removeAt(index);
              });
            },
            background: _buildCompleteTrip(),
            secondaryBackground: _buildRemoveTrip(),
            child: _buildListTile(index),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}
