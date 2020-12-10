import { Field, InputType } from "type-graphql";

import { CreateOwnerInput } from "../owner/CreateOwnerInput";
import { CreatePropertyInput } from "../property/CreatePropertyInput";
import { CreateRepresentativeInput } from "../representative/CreateRepresentativeInput";
import { CreateTenantInput } from "../tenant/CreateTenantInput";

@InputType()
export class CreateStateOfPlayInput {// TODO
  @Field(() => CreatePropertyInput)
  property: CreatePropertyInput;
  
  @Field(() => CreateOwnerInput)
  owner: CreateOwnerInput;
  
  @Field(() => CreateRepresentativeInput)
  representative: CreateRepresentativeInput;

  @Field(() => [CreateTenantInput])
  tenants: [CreateTenantInput]
}
