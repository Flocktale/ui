import 'package:flutter/material.dart';

class CreateClubButton extends StatelessWidget {
  final Function onTap;
  CreateClubButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => (onTap ?? () {})(),
      child: Card(
        elevation: 4,
        shadowColor: Colors.white,
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
              Text("Create Club",
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
