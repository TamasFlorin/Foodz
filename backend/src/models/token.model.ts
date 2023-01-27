import { model, Schema, Document } from 'mongoose';
import { RefreshToken } from '@interfaces/token.interface';

const refreshTokenSchema: Schema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  token: {
    type: String,
    required: true,
  },
  created: { type: Date, default: Date.now },
  revoked: Date,
});

const userModel = model<RefreshToken & Document>('RefreshToken', refreshTokenSchema);
export default userModel;
