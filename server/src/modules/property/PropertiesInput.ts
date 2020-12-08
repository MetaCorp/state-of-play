import { Field, InputType } from "type-graphql";

@InputType()
export class PropertiesInput {
  @Field()
  userId: string;
}
