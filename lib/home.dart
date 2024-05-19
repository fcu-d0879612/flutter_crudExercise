import 'package:crud/add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Home extends StatefulWidget {
  final Future<Database> database;
  const Home({super.key, required this.database});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _hero = [];
  List<Map<String, dynamic>> _dropdownItems = [];

  int? _selectedHeroId;

  @override
  void initState() {
    super.initState();
    refreshHero();
  }

  Future<void> deleteHero(int id) async {
    final Database db = await widget.database;
    await db.delete(
      'hero',
      where: 'id=?',
      whereArgs: [id],
    );
    refreshHero();
  }

  Future<void> updateHero(int id, String heroName, String firstName,
      String lastName, String city) async {
    final Database db = await widget.database;
    await db.update(
      'hero',
      {
        'hero_name': heroName,
        'first_name': firstName,
        'last_name': lastName,
        'city': city,
      },
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<void> getOneHero(int id) async {
    final Database db = await widget.database;
    final List<Map<String, dynamic>> result =
        await db.query('hero', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _hero = result;
    });
  }

  Future<void> refreshHero() async {
    final Database db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('hero');

    setState(() {
      _hero = maps;
      _selectedHeroId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD_APP'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ! 只能選一次
              DropdownButton<int>(
                hint: Text('Select ID'),
                value: _selectedHeroId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedHeroId = newValue;
                  });
                },
                items: _hero
                    .map<DropdownMenuItem<int>>((Map<String, dynamic> hero) {
                  return DropdownMenuItem<int>(
                    value: hero['id'],
                    child: Text(hero['id'].toString()),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_selectedHeroId != null) {
                    getOneHero(_selectedHeroId!);
                  }
                },
                child: Text('Get One'),
              ),
              ElevatedButton(
                onPressed: refreshHero,
                child: Text('Get All'),
              ),
              //  *Add
              ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Add(database: widget.database)),
                    );
                    if (result == true) {
                      refreshHero();
                    }
                  },
                  child: Text('Add'))
            ],
          ),
          //* 資料顯示
          Expanded(
            child: ListView.builder(
              itemCount: _hero.length,
              itemBuilder: (context, index) {
                final hero = _hero[index];
                return ListTile(
                  title: Text("ID:${hero['id']}    ${hero['hero_name']}"),
                  subtitle: Text(
                      "First Name:${hero['first_name']}\nLast Name:${hero['last_name']}\nCity: ${hero['city']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Add(
                                  database: widget.database, editHero: hero),
                            ),
                            /* 
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Edit"),
                              content: Column(
                                children: [
                                  TextField(
                                    controller: _hNameController,
                                    decoration: InputDecoration(
                                        hintText: 'HeroName',
                                        border: OutlineInputBorder()),
                                  ),
                                  TextField(
                                    controller: _fNameController,
                                    decoration: InputDecoration(
                                        hintText: 'FirstName',
                                        border: OutlineInputBorder()),
                                  ),
                                  TextField(
                                    controller: _lNameController,
                                    decoration: InputDecoration(
                                        hintText: 'LastName',
                                        border: OutlineInputBorder()),
                                  ),
                                  TextField(
                                    controller: _cityController,
                                    decoration: InputDecoration(
                                        hintText: 'City',
                                        border: OutlineInputBorder()),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await updateHero(
                                          hero['id'],
                                          _hNameController.text,
                                          _fNameController.text,
                                          _lNameController.text,
                                          _cityController.text);
                                      Navigator.pop(context);
                                      refreshHero();
                                    },
                                    child: Text('Update'))
                              ],
                            ),
                            */
                          );
                        },
                      ),
                      TextButton(
                          onPressed: () async {
                            await deleteHero(hero['id']);
                          },
                          child: Icon(Icons.delete)),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
