import { Row, Col, Form, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';

function SongDisplay({song}) {
  console.log(song);
  return (
    <Col md="3">
      <Card className="party-card">
        <Card.Title>{song.title}</Card.Title>
        <Card.Text>
          By {song.artist}<br />
        </Card.Text>
        <Button variant="primary">Add To Queue</Button>
      </Card>
    </Col>
  );
}

export default function ShowSongs({songs}) {
  console.log(songs);
    let song_cards = songs.map((song) => (
      <SongDisplay song={song} key={song.id} />
    ));

    return (
      <Row>
        {song_cards}
      </Row>
    );
}
