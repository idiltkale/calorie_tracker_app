part of 'theme_bloc.dart';


 class ThemeState extends Equatable  {
   final bool switchvalue ;

  const ThemeState({required this.switchvalue});

  @override
  List<Object> get props => [switchvalue];

  Map<String,dynamic> toMap(){
    return{
      'switchvalue':switchvalue,
    };
  }
  factory ThemeState.fromMap(Map<String,dynamic> map){
    return ThemeState(
      switchvalue: map['switchvalue'] ?? false);
  }



}

 class ThemeInitial extends ThemeState {
  const ThemeInitial({required bool switchvalue}) : super(switchvalue : switchvalue);
}
