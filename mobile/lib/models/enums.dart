enum Role {
  ADMIN,
  CARRIER,
  USER,
}

enum OrderStatus {
  PENDING,
  ASSIGNED,
  COMPLETED
}

Role roleFromJson(String role) {
  switch (role) {
    case 'ADMIN':
      return Role.ADMIN;
    case 'CARRIER':
      return Role.CARRIER;
    case 'USER':
      return Role.USER;
    default:
      return Role.USER;
  }
}

String parseOrderStatus(OrderStatus orderStatus) {
  switch (orderStatus) {
    case OrderStatus.PENDING:
      return 'Kurye Bekliyor';
    case OrderStatus.ASSIGNED:
      return 'Kurye Atandı';
    case OrderStatus.COMPLETED:
      return 'Teslim Edildi';
    default:
      return 'Kurye Bekliyor';
  }
}

OrderStatus orderStatusFromJson(String orderStatus) {
  switch (orderStatus) {
    case 'PENDING':
      return OrderStatus.PENDING;
    case 'ASSIGNED':
      return OrderStatus.ASSIGNED;
    case 'COMPLETED':
      return OrderStatus.COMPLETED;
    default:
      return OrderStatus.PENDING;
  }
}


