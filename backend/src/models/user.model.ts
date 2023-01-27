import { model, Schema, Document } from 'mongoose';
import { User, UserRole } from '@interfaces/user.interface';
import { Status } from '@interfaces/status.interface';

const userSchema: Schema = new Schema({
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
    select: false,
  },
  role: {
    type: String,
    enum: UserRole,
    default: UserRole.Regular,
    required: true,
  },
  firstName: {
    type: String,
    required: true,
  },
  lastName: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    enum: Status,
    default: Status.Active,
    required: true,
  },
});

const userModel = model<User & Document>('User', userSchema);
export default userModel;
