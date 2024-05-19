import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final _formKey = GlobalKey<FormState>();

class Add extends StatefulWidget {
  final Future<Database> database;
  final Map<String, dynamic>? editHero; // 接收要編輯的英雄數據
  const Add({super.key, required this.database, this.editHero});
  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController _hNameController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  List<Map<String, dynamic>> _hero = [];

  @override
  void initState() {
    super.initState();
    if (widget.editHero != null) {
      _hNameController.text = widget.editHero!['hero_name'];
      _fNameController.text = widget.editHero!['first_name'];
      _lNameController.text = widget.editHero!['last_name'];
      _cityController.text = widget.editHero!['city'];
    }
  }

  @override
  Future<void> insertHero(
      String heroName, String firstName, String lastName, String city) async {
    final Database db = await widget.database;
    await db.insert(
      'hero',
      {
        'hero_name': heroName,
        'first_name': firstName,
        'last_name': lastName,
        'city': city,
      },
    );
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

  Future<void> deleteHero(int id) async {
    final Database db = await widget.database;
    await db.delete(
      'hero',
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<void> refreshHero() async {
    final Database db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('hero');
    setState(() {
      _hero = maps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            //*如果是 Edit進來的話title會改變
            widget.editHero == null ? 'Add' : 'Edit'),
      ),
      body: Form(
        key: _formKey,
        //* autovalidateMode设定为AutovalidateMode.onUserInteraction，用戶互動時自動進行校驗
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              HeroName(),
              SizedBox(height: 30),
              FisrtName(),
              SizedBox(height: 30),
              LastName(),
              SizedBox(height: 30),
              City(),
              ElevatedButton(
                onPressed: () async {
                  /*await insertHero(_hNameController.text, _fNameController.text,
                    _lNameController.text, _cityController.text);*/
                  //refreshHero();
                  //* 使用_formKey.currentState?.validate()觸發表單的校驗
                  if (_formKey.currentState?.validate() ?? false) {
                    if (widget.editHero == null) {
                      await insertHero(
                        _hNameController.text,
                        _fNameController.text,
                        _lNameController.text,
                        _cityController.text,
                      );
                    } else {
                      await updateHero(
                        widget.editHero!['id'],
                        _hNameController.text,
                        _fNameController.text,
                        _lNameController.text,
                        _cityController.text,
                      );
                    }
                  }
                  ;
                  if (_formKey.currentState?.validate() ?? false) {
                    //* 如果所有的表單項目校驗 return null，符合所有要求，可以Save＋回傳
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('儲存成功')));
                    Navigator.pop(context, true);
                  }
                },
                child: Text(widget.editHero == null ? 'Submit' : 'Update'),

                /*
              Expanded(
                child: ListView.builder(itemBuilder: (context, index) {
                  final hero = _hero[index];
                  return ListTile(
                    title: Text(data),
                  );
                }),
              )*/
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField City() {
    return TextFormField(
      controller: _cityController,
      decoration: const InputDecoration(labelText: 'City'),
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '不能為空';
        }
        return null;
      },
    );
  }

  TextFormField LastName() {
    return TextFormField(
      controller: _lNameController,
      decoration: InputDecoration(labelText: 'LastName'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '不能為空';
        }
        return null;
      },
    );
  }

  TextFormField FisrtName() {
    return TextFormField(
        controller: _fNameController,
        decoration: InputDecoration(labelText: 'FirstName'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '不能為空';
          }
          return null;
        });
  }

  TextFormField HeroName() {
    return TextFormField(
      controller: _hNameController,
      decoration: InputDecoration(labelText: 'HeroName'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          //* 沒有input, return 錯誤信息
          return '不能為空';
        }
        //* 如果一切正常，返回null
        return null;
      },
    );
  }
}
