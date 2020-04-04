create or replace procedure covid19.insert_places_cases_diff(
  _place_name varchar(32),
  _infected_diff integer,
  _cured_diff integer,
  _fatal_diff integer,
  _sources text
)
language plpgsql
as $$
  declare
    _place_id integer;
    _latest_infected integer;
    _latest_cured integer;
    _latest_fatal integer;
  begin
    select p.id into _place_id from covid19.places p where name=_place_name;

    if _place_id is null then
      raise exception 'Nonexistent place --> %', _place_name using hint = 'Please check your place name';
    else
      select pc.infected, pc.cured, pc.fatal
      into _latest_infected, _latest_cured, _latest_fatal
      from covid19.places_cases pc
      where pc.place_id = _place_id
      order by timestamp desc
      limit 1;

      insert into covid19.places_cases (place_id, infected, cured, fatal, sources, timestamp)
      values (
        _place_id,
        coalesce(_latest_infected, 0) + _infected_diff,
        coalesce(_latest_cured, 0) + _cured_diff,
        coalesce(_latest_fatal, 0) + _fatal_diff,
        _sources,
        current_timestamp
      );
    end if;
  end
$$;
