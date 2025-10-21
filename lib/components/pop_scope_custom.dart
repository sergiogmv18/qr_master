import 'package:flutter/material.dart';

 /*
  * Component to use in the widget to prevent rollback, depending on the bool
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @param   <bool> canPop - When false, blocks the current route from being popped.
  * @param <Widget> Widget to body of PopScope
  * @return  PopScope
  */


PopScope popScopeCustom({bool canPop = true,void Function(bool, Object?)? onPopInvokedWithResult,required Widget child}){
  return PopScope(
    canPop: canPop, 
    onPopInvokedWithResult:onPopInvokedWithResult,
    child:child,
  );
}