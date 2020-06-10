class BangModel {
  final String speda;
  final String rojHalat;
  final String nevro;
  final String evar;
  final String makhrab;
  final String aisha;

  BangModel(this.speda, this.rojHalat, this.nevro, this.evar, this.makhrab,
      this.aisha);


      @override
  String toString() {
    return '$speda, $rojHalat, $nevro, $evar, $makhrab , $aisha';
  }
}
