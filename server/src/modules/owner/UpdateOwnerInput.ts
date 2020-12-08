import { Field, InputType } from "type-graphql";
import { CreateOwnerInput } from "./CreateOwnerInput";

@InputType()
export class UpdateOwnerInput {  
    @Field()
    ownerId: string;

    @Field()
    owner: CreateOwnerInput
}
