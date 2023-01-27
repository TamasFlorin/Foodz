import { Request } from 'express';
import { Status } from './status.interface';

export enum UserRole {
  Regular = 'REGULAR',
  Owner = 'OWNER',
  Admin = 'ADMIN',
}

export interface User {
  _id: string;
  email: string;
  password: string;
  role: UserRole;
  firstName: string;
  lastName: string;
  status: Status;
}

export interface TokenData {
  token: string;
  refreshToken: string;
  userId: string;
  role: UserRole;
  expiresIn: number;
}

export interface TokenPayload {
  userId: string;
}

export interface RequestWithUser extends Request {
  user: User;
}

export interface Users {
  users: User[];
}
