import 'package:flutter/material.dart';

class DialogProgressBar extends StatelessWidget {
  bool isLoading;
  bool forPagination;

  DialogProgressBar(
      {Key? key, required this.isLoading, this.forPagination = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !(isLoading)
        ? const Offstage()
        : (forPagination)
            ? const SizedBox(
                height: 70,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff33A1E1)),
                )),
              )
            : AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff33A1E1)),
                      ))),
                ),
              );
  }
}
