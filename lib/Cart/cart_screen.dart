import 'package:flutter/material.dart';
import 'package:skilla/utils/components/custom_app_bar.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/model/course.dart';
import 'package:skilla/utils/text_styles.dart';

class CartScreen extends StatefulWidget {
  final List<Course> _cart;

  CartScreen(this._cart);

  @override
  _CartScreenState createState() => _CartScreenState(this._cart);
}

class _CartScreenState extends State<CartScreen> {
  _CartScreenState(this._cart);

  List<Course> _cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleImg: kAppBarImg,
        center: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  var item = _cart[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Card(
                      elevation: 4.0,
                      child: ListTile(
                        leading: Icon(
                          item.icon,
                          color: item.color,
                        ),
                        title: Text(item.name),
                        subtitle: Text(item.price),
                        trailing: GestureDetector(
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onTap: () {
                              setState(() {
                                _cart.remove(item);
                              });
                            }),
                      ),
                    ),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'TOTAL:',
                style: TextStyles.paragraph(
                  TextSize.xLarge,
                  weight: FontWeight.bold,
                ),
              ),
              Text(
                'R\$ 0,00',
                style: TextStyles.paragraph(
                  TextSize.xLarge,
                  weight: FontWeight.bold,
                ),
              ),
              Text(
                'Itens: ${_cart.length}',
                style: TextStyles.paragraph(
                  TextSize.xLarge,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
