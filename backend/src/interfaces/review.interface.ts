import { Status } from './status.interface';

export interface Review {
  _id: string;
  userId: string;
  restaurantId: string;
  content: string;
  reply: string;
  rating: number;
  dateOfVisit: Date;
  status: Status;
}

export interface Reviews {
  reviews: Review[];
}
