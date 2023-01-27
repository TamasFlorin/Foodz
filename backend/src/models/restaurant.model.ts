import { model, Schema, Document } from 'mongoose';
import { Restaurant } from '@interfaces/restaurant.interface';
import { Status } from '@interfaces/status.interface';

const restaurantSchema: Schema = new Schema({
  ownerId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  status: { type: String, enum: Status, default: Status.Active },
  created: { type: Date, default: Date.now },
  averageRating: { type: Number, default: 0.0 },
  numReviews: { type: Number, default: 0 },
  reviewSum: { type: Number, default: 0 },
});

restaurantSchema.index({ averageRating: -1 });
restaurantSchema.index({ name: 1 });
restaurantSchema.index({ address: 1 });

const restaurantModel = model<Restaurant & Document>('Restaurant', restaurantSchema);
export default restaurantModel;
