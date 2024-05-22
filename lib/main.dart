import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();

  void _startGame() {
    if (_player1Controller.text.isNotEmpty && _player2Controller.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            player1: _player1Controller.text,
            player2: _player2Controller.text,
          ),
        ),
      );
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Please enter names for both players'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _player1Controller,
                decoration: InputDecoration(
                  labelText: 'Player 1 Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _player2Controller,
                decoration: InputDecoration(
                  labelText: 'Player 2 Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Start Game',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  GameScreen({required this.player1, required this.player2});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String _result = '';

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isXTurn = true;
      _result = '';
    });
  }

  void _handleTap(int index) {
    if (_board[index] == '' && _result == '') {
      setState(() {
        _board[index] = _isXTurn ? 'X' : 'O';
        _isXTurn = !_isXTurn;
        _result = _checkWinner();
      });
    }
  }

  String _checkWinner() {
    const List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6] // Diagonals
    ];

    for (var pattern in winPatterns) {
      String first = _board[pattern[0]];
      if (first != '' &&
          first == _board[pattern[1]] &&
          first == _board[pattern[2]]) {
        return '${first == 'X' ? widget.player1 : widget.player2} wins!';
      }
    }

    if (_board.every((element) => element != '')) {
      return 'Draw!';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${widget.player1} (X) vs ${widget.player2} (O)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          _buildBoard(),
          SizedBox(height: 20),
          Text(
            _result,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: Text(
              'Reset Game',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: _buildCell,
        itemCount: 9,
        shrinkWrap: true,
      ),
    );
  }

  Widget _buildCell(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            _board[index],
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _board[index] == 'X' ? Colors.blue : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
