// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final int typeId = 1;

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      gender: fields[0] as String?,
      dob: fields[1] as DateTime?,
      customerGuid: fields[2] as String?,
      username: fields[3] as String?,
      firstName: fields[4] as String?,
      lastName: fields[5] as String?,
      email: fields[6] as String?,
      phoneNumber: fields[7] as String?,
      emailToRevalidate: fields[8] as dynamic,
      adminComment: fields[9] as dynamic,
      isTaxExempt: fields[10] as bool?,
      notificationEnabled: fields[11] as bool?,
      pushNotificationforMob: fields[12] as bool?,
      affiliateId: fields[13] as int?,
      vendorId: fields[14] as int?,
      hasShoppingCartItems: fields[15] as bool?,
      requireReLogin: fields[16] as bool?,
      failedLoginAttempts: fields[17] as int?,
      cannotLoginUntilDateUtc: fields[18] as dynamic,
      active: fields[19] as bool?,
      deleted: fields[20] as bool?,
      isSystemAccount: fields[21] as bool?,
      systemName: fields[22] as dynamic,
      lastIpAddress: fields[23] as dynamic,
      createdOnUtc: fields[24] as DateTime?,
      lastLoginDateUtc: fields[25] as dynamic,
      lastActivityDateUtc: fields[26] as DateTime?,
      registeredInStoreId: fields[27] as int?,
      billingAddressId: fields[28] as dynamic,
      shippingAddressId: fields[29] as dynamic,
      pictureId: fields[30] as dynamic,
      id: fields[31] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.gender)
      ..writeByte(1)
      ..write(obj.dob)
      ..writeByte(2)
      ..write(obj.customerGuid)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.firstName)
      ..writeByte(5)
      ..write(obj.lastName)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phoneNumber)
      ..writeByte(8)
      ..write(obj.emailToRevalidate)
      ..writeByte(9)
      ..write(obj.adminComment)
      ..writeByte(10)
      ..write(obj.isTaxExempt)
      ..writeByte(11)
      ..write(obj.notificationEnabled)
      ..writeByte(12)
      ..write(obj.pushNotificationforMob)
      ..writeByte(13)
      ..write(obj.affiliateId)
      ..writeByte(14)
      ..write(obj.vendorId)
      ..writeByte(15)
      ..write(obj.hasShoppingCartItems)
      ..writeByte(16)
      ..write(obj.requireReLogin)
      ..writeByte(17)
      ..write(obj.failedLoginAttempts)
      ..writeByte(18)
      ..write(obj.cannotLoginUntilDateUtc)
      ..writeByte(19)
      ..write(obj.active)
      ..writeByte(20)
      ..write(obj.deleted)
      ..writeByte(21)
      ..write(obj.isSystemAccount)
      ..writeByte(22)
      ..write(obj.systemName)
      ..writeByte(23)
      ..write(obj.lastIpAddress)
      ..writeByte(24)
      ..write(obj.createdOnUtc)
      ..writeByte(25)
      ..write(obj.lastLoginDateUtc)
      ..writeByte(26)
      ..write(obj.lastActivityDateUtc)
      ..writeByte(27)
      ..write(obj.registeredInStoreId)
      ..writeByte(28)
      ..write(obj.billingAddressId)
      ..writeByte(29)
      ..write(obj.shippingAddressId)
      ..writeByte(30)
      ..write(obj.pictureId)
      ..writeByte(31)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
