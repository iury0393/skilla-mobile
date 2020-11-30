import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skilla/utils/components/custom_app_bar.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/model/course.dart';
import 'package:skilla/utils/text_styles.dart';

import 'cart_screen.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<Course> _courses = List<Course>();
  List<Course> _events = List<Course>();

  List<Course> _cartList = List<Course>();

  @override
  void initState() {
    super.initState();
    _populateEvents();
    _populateCourses();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: Container(),
          title: Container(
            child: Image.network(kAppBarImg),
          ),
          centerTitle: true,
          actions: [
            _buildFlatBtn(context),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Cursos',
                  style: TextStyles.paragraph(
                    TextSize.small,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Palestras',
                  style: TextStyles.paragraph(
                    TextSize.small,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGridViewCourse(),
            _buildGridViewEvents(),
          ],
        ),
      ),
    );
  }

  Padding _buildFlatBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 8.0),
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              size: 36.0,
              color: kSkillaPurple,
            ),
            if (_cartList.length > 0)
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: Text(
                    _cartList.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          if (_cartList.isNotEmpty)
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CartScreen(_cartList),
              ),
            );
        },
      ),
    );
  }

  GridView _buildGridViewCourse() {
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        var item = _courses[index];
        return Card(
          elevation: 4.0,
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    item.icon,
                    color:
                        (_cartList.contains(item)) ? Colors.grey : item.color,
                    size: 100.0,
                  ),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  bottom: 8.0,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    child: (!_cartList.contains(item))
                        ? Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                    onTap: () {
                      setState(() {
                        if (!_cartList.contains(item))
                          _cartList.add(item);
                        else
                          _cartList.remove(item);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  GridView _buildGridViewEvents() {
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        var item = _events[index];
        return Card(
          elevation: 4.0,
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    item.icon,
                    color:
                        (_cartList.contains(item)) ? Colors.grey : item.color,
                    size: 100.0,
                  ),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  bottom: 8.0,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    child: (!_cartList.contains(item))
                        ? Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                    onTap: () {
                      setState(() {
                        if (!_cartList.contains(item))
                          _cartList.add(item);
                        else
                          _cartList.remove(item);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _populateCourses() {
    var list = <Course>[
      Course(
        name: 'Curso Javascript',
        icon: FontAwesomeIcons.jsSquare,
        color: Colors.amber,
      ),
      Course(
        name: 'Curso Android',
        icon: FontAwesomeIcons.android,
        color: Colors.green,
      ),
      Course(
        name: 'Curso Swift',
        icon: FontAwesomeIcons.swift,
        color: Colors.orange,
      ),
      Course(
        name: 'Curso React',
        icon: FontAwesomeIcons.react,
        color: Colors.blue,
      ),
      Course(
        name: 'Curso SQLServer',
        icon: FontAwesomeIcons.database,
        color: Colors.orangeAccent,
      ),
      Course(
        name: 'Curso Node.JS',
        icon: FontAwesomeIcons.nodeJs,
        color: Colors.greenAccent,
      ),
    ];

    setState(() {
      _courses = list;
    });
  }

  void _populateEvents() {
    var list = <Course>[
      Course(
        name: 'Introdução a inteligência Artificial',
        icon: FontAwesomeIcons.robot,
        color: Colors.amber,
      ),
      Course(
        name: 'AgroNegócio e Tecnologia, como conciliar?',
        icon: FontAwesomeIcons.tree,
        color: Colors.green,
      ),
      Course(
        name: 'Home-Office, uma nova realidade',
        icon: FontAwesomeIcons.houseUser,
        color: Colors.blue,
      ),
      Course(
        name: 'Aumente sua produtividade em 100%',
        icon: FontAwesomeIcons.arrowUp,
        color: Colors.red,
      ),
    ];

    setState(() {
      _events = list;
    });
  }
}
