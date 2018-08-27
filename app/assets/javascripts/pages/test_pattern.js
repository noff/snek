window.testPattern = function() {

    // Init app
    window.tester = new Vue({

        el: '#test-pattern',

        data: {
            battle_id: null,
            pattern: null,
            rounds: [],
            arena: null,
            snek_names: [],
            sneks: [],
            selected_snek: null,
            currentRound: 0,
            totalRounds: null,
            final_direction: null
        },

        methods: {

            // Opens test pattern dialog
            testPattern: function(id) {
                this.pattern = window.app.rules[id];
                this.reset();
            },

            // Loads battle info and renders arena
            selectSavedBattle: function() {

                this.reset();

                var battle_id = $('#battle-selector').val() || null;
                this.battle_id = battle_id;
                var _this = this;

                if(battle_id) {
                    $.ajax({
                        dataType: "json",
                        url: '/battles/' + battle_id + '/data',
                        data: {},
                        success: function(response) {
                            _this.rounds = response.rounds;
                            _this.arena = response.arena;
                            _this.snek_names = response.snek_names;
                            _this.sneks = response.sneks;
                            _this.totalRounds = response.rounds.length;
                            _this.drawRound(0);
                        }
                    });
                }

            },

            reset: function() {
                this.selected_snek = null;
                this.battle_id = null;
                this.currentRound = 0;
                $('#snek-selector').html('');
                this.currentRound = 0;
                $('#test-arena').empty();
            },

            selectSnek: function() {
                var snek = $('#snek-selector').val();
                this.selected_snek = snek ? parseInt(snek) : null;
                this.drawRound(this.currentRound)
            },

            drawRound: function(id) {
                var round = this.rounds[id];

                this.final_direction = null;

                // Draw sneks selector
                var sneks = round.sneks;
                var options = "<option>Select snek</option>";
                for (var i in sneks) {
                    var has_current = false;
                    if (sneks.hasOwnProperty(i)) {
                        var snekId = sneks[i].snek_id;
                        if (this.selected_snek === snekId) {
                            has_current = true;
                        }
                        options += "<option value='" + snekId + "' " + (has_current ? 'selected' : '') + " >" + this.snek_names[snekId] + "</option>";
                    }
                }
                $('#snek-selector').html(options);
                if (!has_current) {
                    this.selected_snek = null;
                }

                // Draw rounds selector
                $('#round-selector').prop('max', this.rounds.length - 1);

                // Draw arena
                var html = '';
                this.arena.forEach(function(row, y){
                    html += '<tr>';
                    row.forEach(function(cell, x) {
                        if(cell == 'wall') {
                            html += '<td class="wall"></td>';
                        } else {
                            html += '<td class="empty" id="c_' +  x + '_' + y + '"></td>';
                        }
                    });
                    html += '</tr>';
                });
                $('#test-arena').html(html);
                resizeArena();

                // Draw sneks on arena
                var _this = this;
                var direction_code = '';
                var cell_html = '';
                round.sneks.forEach(function(snek, snek_number){
                    snek.position.forEach(function (position, index) {
                        direction_code = _this.directionClass(index, snek);

                        var class_skin = '" class="' + direction_code + '"';
                        var class_body = '" class="' + direction_code ;
                        if (_this.selected_snek === snek.snek_id) {
                            class_body += ' selected-snek"'
                        } else {
                            class_body += '"'
                        }

                        if(index === 0) {
                            cell_html = '<img src="' + _this.sneks[snek.snek_id].style.head + class_body + ' title="' + _this.sneks[snek.snek_id].name + '">';
                            $('#c_' + position.x + '_' + position.y).html(cell_html);
                        } else if (index !== (snek.position.length - 1) ) {
                            if( snek.position[index-1].x !== snek.position[index+1].x && snek.position[index-1].y !== snek.position[index+1].y ) {
                                cell_html = '<img src="' + _this.sneks[snek.snek_id].style.curve + class_body + '>';
                                cell_html += '<img src="' + _this.sneks[snek.snek_id].style.curve_pattern + class_skin + '>';
                                $('#c_' + position.x + '_' + position.y).html(cell_html);
                            } else {
                                cell_html = '<img src="' + _this.sneks[snek.snek_id].style.body + class_body + '>';
                                cell_html += '<img src="' + _this.sneks[snek.snek_id].style.body_pattern + class_skin + '>';
                                $('#c_' + position.x + '_' + position.y).html(cell_html);
                            }
                        } else {
                            cell_html = '<img src="' + _this.sneks[snek.snek_id].style.tail + class_body + '>';
                            cell_html += '<img src="' + _this.sneks[snek.snek_id].style.tail_pattern + class_skin + '>';
                            $('#c_' + position.x + '_' + position.y).html(cell_html);
                        }
                    });
                });

            },

            /**
             * Get cell direction CSS class
             */
            directionClass: function(position_index, snek_data) {
                var position = snek_data.position;
                var prev = position[position_index - 1];
                var curr = position[position_index];
                var next = position[position_index + 1];

                // Head
                if(prev == null) {
                    if (next.x === curr.x) {
                        if (next.y > curr.y) {
                            return 'cell-up';
                        } else {
                            return 'cell-down';
                        }
                    } else if (next.y === curr.y) {
                        if (next.x > curr.x) {
                            return 'cell-left';
                        } else {
                            return 'cell-right';
                        }
                    }
                }

                // Tail
                if (next == null) {
                    if (prev.x === curr.x) {
                        if (prev.y > curr.y) {
                            return 'cell-down';
                        } else {
                            return 'cell-up';
                        }
                    } else if (prev.y === curr.y) {
                        if (prev.x > curr.x) {
                            return 'cell-right';
                        } else {
                            return 'cell-left';
                        }
                    }
                }

                // Body
                if( prev && next && curr ) {
                    // Horizontal
                    if( prev.y === next.y ) {
                        return 'cell-left';
                        // Vertical
                    } else if (prev.x === next.x ) {
                        return 'cell-up';
                        // Will be curve
                    } else {

                        // Position ⌝. Don't rotate
                        if (prev.y === curr.y && prev.y < next.y && prev.x < curr.x && curr.x === next.x) {
                            return 'cell-left';
                        }
                        if (next.y === curr.y && next.y < prev.y && next.x < curr.x && curr.x === prev.x) {
                            return 'cell-left';
                        }

                        // Position ⌜.
                        if (prev.y === curr.y && prev.y < next.y && prev.x > curr.x && curr.x === next.x) {
                            return 'cell-down';
                        }
                        if (next.y === curr.y && next.y < prev.y && next.x > curr.x && curr.x === prev.x) {
                            return 'cell-down';
                        }

                        // Position ⌞.
                        if (prev.y === curr.y && prev.y > next.y && prev.x > curr.x && curr.x === next.x) {
                            return 'cell-right';
                        }
                        if (next.y === curr.y && next.y > prev.y && next.x > curr.x && curr.x === prev.x) {
                            return 'cell-right';
                        }

                        // Position ⌟.
                        if (prev.y === curr.y && prev.y > next.y && prev.x < curr.x && curr.x === next.x) {
                            return 'cell-up';
                        }
                        if (next.y === curr.y && next.y > prev.y && next.x < curr.x && curr.x === prev.x) {
                            return 'cell-up';
                        }

                    }

                }

                return '';
            },

            nextRound: function(){
                if(this.currentRound < (this.totalRounds - 1) ) {
                    this.currentRound++;
                }
            },

            prevRound: function() {
                if(this.currentRound > 0) {
                    this.currentRound--;
                }
            },

            gotoBeginning: function(){
                this.currentRound = 0;
            },

            gotoEnd: function(){
                this.currentRound = this.rounds.length - 1;
            },

            runTest: function() {

                var _this = this;

                var data = {
                    battle_id: this.battle_id,
                    round: this.currentRound,
                    snek_id: this.selected_snek,
                    pattern: JSON.stringify(this.pattern)
                };

                $.ajax({
                    dataType: "json",
                    url: '/sneks/test_pattern',
                    type: 'post',
                    data: data,
                    success: function(response) {
                        _this.final_direction = response.direction;
                    }
                });

            }


        },

        watch: {
            currentRound: function(newValue, oldValue) {
                if(this.battle_id !== null) {
                    this.drawRound(newValue);
                }
            },

            pattern: function(newPattern, _) {
                if(newPattern) {
                    var html = '<table class="r-pattern-table">';
                    newPattern.forEach(function(row, y){
                        html += "<tr>";
                        row.forEach(function(cell, x){
                            var classes = 'r-pattern-cell r-pattern-cell__' + newPattern[y][x][0];
                            switch(newPattern[y][x][1]) {
                                case 'or':
                                    classes += ' r-pattern-cell__or';
                                    break;
                                case 'not':
                                    classes += ' r-pattern-cell__not';
                                    break;
                            }
                            html += "<td class='" + classes + "'></td>";
                        });
                        html += "</tr>";
                    });
                    html += '</table>';
                    $('#test-pattern-container').html(html);
                    $('#test-pattern-container .r-pattern-table').height(223);
                    $('#test-pattern-container .r-pattern-table').width(223);
                    $('#test-pattern-container .r-pattern-table td').height($('#test-pattern-container .r-pattern-table td').width());
                } else {
                    $('#test-pattern-container').empty();
                }



            }
        }
    });

};