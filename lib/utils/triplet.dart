class Triplet<K, V, S> {
  K _key;
  V _value;
  S _secondValue;

  Triplet(this._key, this._value, this._secondValue);

  V get value => _value;

  K get key => _key;

  S get secondValue => _secondValue;
}