import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, ManyToMany, ManyToOne } from "typeorm";
import { ObjectType, Field, ID } from "type-graphql";

import { StateOfPlay } from "./StateOfPlay"
import { User } from "./User";

@ObjectType()
@Entity()
export class Tenant extends BaseEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn()
  id: number;

  @Field()
  @Column()
  firstName: string;

  @Field()
  @Column()
  lastName: string;

  @Field(() => [StateOfPlay])
  @ManyToMany(() => StateOfPlay, stateOfPlay => stateOfPlay.tenants)
  stateOfPlays: StateOfPlay[];

  @Field(() => User)
  @ManyToOne(() => User, user => user.tenants)
  user: User;
}
