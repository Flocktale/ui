import 'package:flutter/material.dart';

class CreateFABButton extends StatelessWidget {
  final Function onTap;
  final String title;
  CreateFABButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => (onTap ?? () {})(),
      child: Card(
        elevation: 2,
        shadowColor: Colors.white70,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.redAccent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(
                    fontFamily: "Lato",
                    color: Colors.white,
                    fontSize: 16,
                  )),
              SizedBox(width: 8),
              Icon(
                Icons.add,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
