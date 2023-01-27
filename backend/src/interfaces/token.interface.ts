export interface RefreshToken {
  userId: string;
  token: string;
  created: Date;
  revoked: Date;
}
