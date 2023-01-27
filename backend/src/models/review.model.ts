import { model, Schema, Document } from 'mongoose';
import { Review } from '@interfaces/review.interface';
import { Status } from '@interfaces/status.interface';

const reviewSchema: Schema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  restaurantId: {
    type: Schema.Types.ObjectId,
    ref: 'Restaurant',
    required: true,
  },
  content: {
    type: String,
    required: true,
  },
  dateOfVisit: Date,
  reply: String,
  rating: { type: Number, required: true },
  status: { type: String, enum: Status, default: Status.Active },
  created: { type: Date, default: Date.now },
});

const reviewModel = model<Review & Document>('Review', reviewSchema);
export default reviewModel;
