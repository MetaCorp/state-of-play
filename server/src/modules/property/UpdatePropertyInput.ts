import { Length } from "class-validator";
import { Field, InputType } from "type-graphql";

@InputType()
export class UpdatePropertyInput {
  @Field({ nullable: true })
  id: string;

  @Field()
  @Length(1, 255)
  address: string;

  @Field()
  @Length(3, 10)
  postalCode: string;

  @Field()
  @Length(1, 255)
  city: string;
}
