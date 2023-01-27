export interface Restaurant {
  _id: string;
  ownerId: string;
  name: string;
  address: string;
  created: Date;
  averageRating: number;
  numReviews: number;
  reviewSum: number;
}

export interface Restaurants {
  restaurants: Restaurant[];
}
