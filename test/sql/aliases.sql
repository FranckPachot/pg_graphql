begin;

    create table account(
        id serial primary key,
        email varchar(255) not null
    );


    insert into public.account(email)
    values
        ('aardvark@x.com');


    create table blog(
        id serial primary key,
        owner_id integer not null references account(id),
        name varchar(255) not null
    );


    insert into blog(owner_id, name)
    values
        (1, 'A: Blog 1');

    -- Connection: alias all field types and operation
    select jsonb_pretty(
        graphql.resolve($$
    {
      aA: accountCollection(first: 1) {
        tc: totalCount
        pi: pageInfo {
          hnp: hasNextPage
        }
        e: edges {
          c: cursor
          n: node{
            id_: id
            b: blogCollection {
              tc2: totalCount
            }
          }
        }
      }
    }
        $$)
    );

    select graphql.resolve($$
    query Introspec {
      s: __schema {
        q: queryType {
          n: name
        }
      }
    }
    $$);


rollback;
