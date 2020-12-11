import { Length } from "class-validator";
import { Field, InputType } from "type-graphql";

@InputType()
export class UpdateOwnerInput {
    @Field({ nullable: true })
    id: string;
    
    @Field()
    @Length(1, 255)
    firstName: string;

    @Field()
    @Length(1, 255)
    lastName: string;
}
