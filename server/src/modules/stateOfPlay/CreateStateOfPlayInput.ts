import { Field, InputType } from "type-graphql";

@InputType()
export class CreateStateOfPlayInput {// TODO
  @Field()
  userId: string;

  @Field()
  propertyId: string;
  
  @Field()
  ownerId: string;

  @Field()
  representativeId: string;
}
