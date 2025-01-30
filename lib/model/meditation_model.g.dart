
part of 'meditation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeditationModelAdapter extends TypeAdapter<MeditationModel> {
  @override
  final int typeId = 0;

  @override
  MeditationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeditationModel(
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MeditationModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeditationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
